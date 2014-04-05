.PHONY: clean gemas
# El siguiente makefile se asegura de que las gemas estan compiladas
# de manera que haya problemas al tratar de ejecutar practica 1

DIR_BASIC_CWP = "lib/CWP/BasicCWP/"
DIR_BASIC_PHUB = "lib/PHUB/BasicPHub/"
DIR_CAPACITED_PHUB = "lib/PHUB/CapacitedPHubNode/"
DIR_ES = "lib/ES/ES/"
DIR_BASIC_MMDP = "lib/MMDP/BasicMMDP/"
DIR_MMDP = "lib/MMDP/MMDP"

all: gemas
gemas: gema_c_basic_cwp gema_c_capacited_phub gema_c_basic_phub gema_es gema_c_basic_mmdp gema_c_mmdp
	@echo "Gemas compiladas correctamente"
	
gema_c_basic_cwp:
	@cd $(DIR_BASIC_CWP) ; \
	ruby extconf.rb;\
	make; \
	rm *.o; \
	rm Makefile
	
gema_c_capacited_phub:
	@cd $(DIR_CAPACITED_PHUB);\
	ruby extconf.rb;\
	make;\
	rm *.o; \
	rm Makefile
	
gema_c_basic_phub:
	@cd $(DIR_BASIC_PHUB);\
	ruby extconf.rb;\
	make;\
	rm *.o; \
	rm Makefile

gema_es:
	@cd $(DIR_ES);\
	ruby extconf.rb;\
	make;\
	rm *.o;\
	rm Makefile
	
gema_c_basic_mmdp:
	@cd $(DIR_BASIC_MMDP); \
	ruby extconf.rb; \
	make; \
	rm *.o; \
	rm Makefile

gema_c_mmdp:
	@cd $(DIR_MMDP);\
	ruby extconf.rb;\
	make; \
	rm *.o;\
	rm Makefile

clean:
	-cd $(DIR_BASIC_CWP); \
	rm *.so;
	
	-cd $(DIR_CAPACITED_PHUB); \
	rm *.so;
	
	-cd $(DIR_BASIC_PHUB);\
	rm *.so;

	-cd $(DIR_ES); \
	rm *.so;

	-cd $(DIR_BASIC_MMDP); \
	rm *.so;

	-cd $(DIR_MMDP);\
	rm *.so;