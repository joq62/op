all:
	rm -rf  ebin/* test_ebin/* src/*~ test_src/*~ *~ erl_crash.dump src/*.beam test_src/*.beam;
	cp src/*.app ebin;
doc_gen:
	rm -rf  node_config logfiles doc/*;
	erlc ../doc_gen.erl;
	erl -s doc_gen start -sname doc

test:
	rm -rf  ebin/* test_ebin/* src/*~ test_src/*~ *~ erl_crash.dump src/*.beam test_src/*.beam;
	rm -rf Mnesia*;
#	common
	erlc -o ebin ../common/src/*.erl;
#	iaas support
	erlc -o ebin ../iaas/src/*.erl;
#	control support
	erlc -o ebin ../control/src/*.erl;
#	sd
	erlc -o ebin ../sd/src/*.erl;
	cp src/*app ebin;
	erlc -o ebin src/*.erl;
	erlc -o test_ebin test_src/*.erl;
	erl -pa ebin -pa ebin -pa test_ebin -s op_tests start -sname op -setcookie abc
