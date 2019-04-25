
target  = client
objs    = client.o

##################################

path    = /root/pro/clientPro
lib     = $(path)/lib
inc     = $(path)/inc
##################################
arch    = arm

gxx     = arm-linux-gnueabihf-g++
ldflag  = -g -Wall
cxxflag = -static -g -Wall -I ${SOCEDS_DEST_ROOT}/ip/altera/hps/altera_hps/hwlib/include -std=c++11

##################################

$(target) : $(objs)
	$(gxx) $(ldflag) $^ -o $@ -lpthread -lrt

%.o : %.cpp
	$(gxx) $(cxxflag) -c $< -o $@

.PHONY:clean
clean:
	rm -f $(target) *.o





