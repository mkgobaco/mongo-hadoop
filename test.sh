#! /bin/sh

alias g="./gradlew --daemon"

HV=$1
VERSIONS=(0.23 1.0 1.1 cdh4 cdh5 2.2 2.3 2.4)
VERSIONS=(0.23 cdh4 cdh5 2.2 2.3 2.4)

function choose() {
	if [ -z "${HV}" ]
	then
		echo Choose a hadoop version
		select HV in ${VERSIONS[@]}
		do
			break
		done
	fi
}

function run() {
	g clean jar testJar test -PclusterVersion=${HV} 2>&1 | tee test-${HV}.out
	./build/hadoop-${HV}.sh shutdown
}

if [ "$1" == "all" ]
then
	for HV in ${VERSIONS[@]}
	do
		> test-${HV}.out
	done
	for HV in ${VERSIONS[@]}
	do
		run
	done
else
	choose
	run
fi
