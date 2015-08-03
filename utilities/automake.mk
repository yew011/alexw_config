bin_PROGRAMS += \
	utilities/backdoor

scripts_SCRIPTS += \
	utilities/bundle \
	utilities/locktty

utilities_backdoor_SOURCES = utilities/backdoor.c
utilities_backdoor_LDADD = lib/libalexw.a
utilities_backdoor_CFLAGS = -D_GNU_SOURCE
