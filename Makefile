# this Makefile has been put into the public domain by its sole author:
# Hans-Christoph Steiner <hans@at.or.at>
#
# To use:
#   make generate-sources
#   make
#   make install
#   ilbc-decode

SOURCES = FrameClassify.c LPCdecode.c LPCencode.c StateConstructW.c StateSearchW.c anaFilter.c constants.c createCB.c doCPLC.c enhancer.c filter.c gainquant.c getCBvec.c helpfun.c hpInput.c hpOutput.c iCBConstruct.c iCBSearch.c iLBC_decode.c iLBC_encode.c iLBC_test.c lsf.c packing.c syntFilter.c 

HEADERS = FrameClassify.h LPCdecode.h LPCencode.h StateConstructW.h StateSearchW.h anaFilter.h constants.h createCB.h doCPLC.h enhancer.h filter.h gainquant.h getCBvec.h helpfun.h hpInput.h hpOutput.h iCBConstruct.h iCBSearch.h iLBC_decode.h iLBC_define.h iLBC_encode.h lsf.h packing.h syntFilter.h

ALLFILES = $(SOURCES) $(HEADERS)

prefix = /usr/local

all: ilbc-decode

generate-sources: distclean
	test -x rfc3951.txt || curl http://www.ietf.org/rfc/rfc3951.txt > rfc3951.txt
	curl http://www.ilbcfreeware.org/documentation/extract-cfile.txt > extract-cfile.awk
	awk -f extract-cfile.awk rfc3951.txt

%.o: %.c
	$(CC) $(CFLAGS) -o $*.o -c $*.c

ilbc-decode: $(SOURCES:.c=.o)
	$(CC) $(LDFLAGS) -o ilbc-decode $(SOURCES:.c=.o)

install: ilbc-decode
	install -d $(DESTDIR)$(prefix)/bin
	install -p --strip ilbc-decode $(DESTDIR)$(prefix)/bin/ilbc-decode

clean:
	-rm -f -- $(SOURCES:.c=.o) ilbc-decode

distclean: clean
	-rm -f -- $(SOURCES) $(HEADERS) extract-cfile.awk


.PHONY: generate-sources
