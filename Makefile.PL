use 5.014;
use ExtUtils::MakeMaker;

# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
	NAME          => 'RyzomAPI',
	VERSION_FROM  => 'lib/RyzomAPI.pm', # finds $VERSION

	PREREQ_PM => {
		Mouse => 0,
	},

	test => {
		RECURSIVE_TEST_FILES => 1,
	}
);
