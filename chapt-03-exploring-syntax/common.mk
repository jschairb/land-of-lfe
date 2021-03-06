PROJECT = exploring-syntax
LIB = exploring-syntax
DEPS = ./deps
BIN_DIR = ./bin
EXPM = $(BIN_DIR)/expm
LFE_DIR = $(DEPS)/lfe
LFE_EBIN = $(LFE_DIR)/ebin
LFE = $(LFE_DIR)/bin/lfe
LFEC = $(LFE_DIR)/bin/lfec
LFE_UTILS_DIR = $(DEPS)/lfe-utils
LFEUNIT_DIR = $(DEPS)/lfeunit
SOURCE_DIR = ./src
OUT_DIR = ./ebin
TEST_DIR = ./test
TEST_OUT_DIR = ./.eunit
FINISH = -run init stop -noshell
# Note that ERL_LIBS is for running this project in development and that
# ERL_LIB is for installation.
ERL_LIBS = $(shell find $(DEPS) -maxdepth 1 -exec echo -n '{}:' \;|sed 's/:$$/:./'):$(TEST_OUT_DIR)

get-version:
	@echo
	@echo "Getting version info ..."
	@echo
	@echo -n app.src: ''
	@erl -eval 'io:format("~p~n", [ \
		proplists:get_value(vsn,element(3,element(2,hd(element(3, \
		erl_eval:exprs(element(2, erl_parse:parse_exprs(element(2, \
		erl_scan:string("Data = " ++ binary_to_list(element(2, \
		file:read_file("src/$(LIB).app.src"))))))), []))))))])' \
		$(FINISH)
	@echo -n package.exs: ''
	@grep version package.exs |awk '{print $$2}'|sed -e 's/,//g'
	@echo -n git tags: ''
	@echo `git tag`

# Note that this make target expects to be used like so:
#   $ ERL_LIB=some/path make get-install-dir
#
# Which would give the following result:
#   some/path/$project-1.0.0
#
get-install-dir:
	@echo $(ERL_LIB)/$(PROJECT)-$(shell make get-version)

$(BIN_DIR):
	mkdir -p $(BIN_DIR)

$(EXPM): $(BIN_DIR)
	curl -o $(EXPM) http://expm.co/__download__/expm
	chmod +x $(EXPM)

get-deps:
	@echo "Getting dependencies ..."
	@rebar get-deps
	@for DIR in $(wildcard $(DEPS)/*); \
	do cd $$DIR; echo "Updating $$DIR ..."; \
	git pull; cd - > /dev/null; done

clean-ebin:
	@echo "Cleaning ebin dir ..."
	@rm -f $(OUT_DIR)/*.beam

clean-eunit:
	@echo "Cleaning eunit dir ..."
	@rm -rf $(TEST_OUT_DIR)

compile: get-deps clean-ebin
	@echo "Compiling project code and dependencies ..."
	@rebar compile

compile-no-deps: clean-ebin
	@echo "Compiling only project code ..."
	@rebar compile skip_deps=true

compile-tests: clean-eunit
	@echo "Compiling tests ..."
	@mkdir -p $(TEST_OUT_DIR)
	@ERL_LIBS=$(ERL_LIBS) $(LFEC) -o $(TEST_OUT_DIR) $(TEST_DIR)/*/*[_-]tests.lfe
	@-ERL_LIBS=$(ERL_LIBS) $(LFEC) -o $(OUT_DIR) $(TEST_DIR)/testing[-_]*.lfe

shell: compile
	@clear
	@echo "Starting shell ..."
	@ERL_LIBS=$(ERL_LIBS) $(LFE) -pa $(TEST_OUT_DIR)

shell-no-deps: compile-no-deps
	@clear
	@echo "Starting shell ..."
	@ERL_LIBS=$(ERL_LIBS) $(LFE) -pa $(TEST_OUT_DIR)

clean: clean-ebin clean-eunit
	@rebar clean

check-unit-only:
	@echo
	@echo "------------------"
	@echo "Running unit tests ..."
	@echo "------------------"
	@echo
	@ERL_LIBS=$(ERL_LIBS) erl -pa .eunit -noshell \
	-eval "eunit:test({inparallel,[\
		`ls .eunit/unit*| \
		sed -e 's/.beam//' -e 's/^.eunit\///'| \
		awk '{print "\x27" $$1 "\x27"}'| \
		sed ':a;N;$!ba;s/\n/ /g'`]},[verbose])" \
	-s init stop

check-integration-only:
	@echo
	@echo "-------------------------"
	@echo "Running integration tests ..."
	@echo "-------------------------"
	@echo
	@ERL_LIBS=$(ERL_LIBS) erl -pa .eunit -noshell \
	-eval "eunit:test({inparallel,[\
		`ls .eunit/integration*| \
		sed -e 's/.beam//' -e 's/^.eunit\///'| \
		awk '{print "\x27" $$1 "\x27"}'| \
		sed ':a;N;$!ba;s/\n/ /g'`]},[verbose])" \
	-s init stop

check-system-only:
	@echo
	@echo "--------------------"
	@echo "Running system tests ..."
	@echo "--------------------"
	@echo
	@ERL_LIBS=$(ERL_LIBS) erl -pa .eunit -noshell \
	-eval "eunit:test({inparallel,[\
		`ls .eunit/system*| \
		sed -e 's/.beam//' -e 's/^.eunit\///'| \
		awk '{print "\x27" $$1 "\x27"}'| \
		sed ':a;N;$!ba;s/\n/ /g'`]},[verbose])" \
	-s init stop

check-unit-with-deps: compile compile-tests check-unit-only
check-unit: get-deps compile-no-deps compile-tests check-unit-only
check-integration: compile compile-tests check-integration-only
check-system: compile compile-tests check-system-only
check-all-with-deps: compile compile-tests check-unit-only \
	check-integration-only check-system-only
check-all: get-deps compile-no-deps compile-tests check-unit-only \
	check-integration-only check-system-only

# XXX all the custom test checkers above have an issue, described here:
# 	https://github.com/lfe/lfetool/issues/14
# until that gets fixed, use the target below for Travis CI
check: compile compile-tests
	@rebar eunit verbose=1 skip_deps=true

push-all:
	@echo "Pusing code to github ..."
	git push --all
	git push upstream --all
	git push --tags
	git push upstream --tags

# Note that this make target expects to be used like so:
#    $ ERL_LIB=some/path make install
#
install: INSTALLDIR=$(shell make get-install-dir)
install: compile
	@echo "Installing exploring-syntax ..."
	@if [ "$$ERL_LIB" != "" ]; \
	then mkdir -p $(INSTALLDIR)/$(EBIN); \
		mkdir -p $(INSTALLDIR)/$(SRC); \
		cp -pPR $(EBIN) $(INSTALLDIR); \
		cp -pPR $(SRC) $(INSTALLDIR); \
	else \
		echo "ERROR: No 'ERL_LIB' value is set in the env." \
		&& exit 1; \
	fi

upload: $(EXPM) get-version
	@echo "Preparing to upload exploring-syntax ..."
	@echo
	@echo "Package file:"
	@echo
	@cat package.exs
	@echo
	@echo "Continue with upload? "
	@read
	$(EXPM) publish
