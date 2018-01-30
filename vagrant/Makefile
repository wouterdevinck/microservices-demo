BOXNAME := dockerdevbox

# "make" - build the ova file
all: $(BOXNAME).ova
%.ova:
	$(eval BASE := $(basename $@))
	vagrant --boxname=$(BASE) up
	vagrant halt
	vboxmanage export $(BASE) -o $@
	vagrant destroy -f

# "make clean" - delete the ova file
clean: 
	$(RM) *.ova
ifdef ComSpec
  RM=del /F /Q
else
  RM=rm -f
endif

.PHONY: all clean