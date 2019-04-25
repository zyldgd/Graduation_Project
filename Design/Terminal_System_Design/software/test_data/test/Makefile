#
TARGET = sounder2

# arm-linux-gnueabihf-g++ -static -g -Wall -I D:/APP/EDS/embedded/ip/altera/hps/altera_hps/hwlib/include -std=c++11 
CROSS_COMPILE = arm-linux-gnueabihf-
CFLAGS = -static -g -Wall -I ${SOCEDS_DEST_ROOT}/ip/altera/hps/altera_hps/hwlib/include -std=c++11
LDFLAGS = -g -Wall
GCC = $(CROSS_COMPILE)g++
ARCH= arm


build: $(TARGET)

$(TARGET): main.o hw.o isounder_z.o
	$(GCC) $(LDFLAGS) $^ -o $@ -lpthread -lrt -lm

%.o : %.c
	$(GCC) $(CFLAGS) -c $< -o $@
	
%.o : %.cpp
	$(GCC) $(CFLAGS) -c $< -o $@
	
.PHONY: clean
clean:
	rm -f $(TARGET) *.a *.o *~ 

# main       (hw isounder_z)
# isounder_z (hw           )
# hw


