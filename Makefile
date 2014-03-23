.PHONY: clean gemas
# El siguiente makefile se asegura de que las gemas estan compiladas
# de manera que haya problemas al tratar de ejecutar practica 1

all: gemas
gemas: gema_c_basic_cwp gema_c_capacited_phub gema_c_basic_phub
	@echo "Gemas compiladas correctamente"
	
gema_c_basic_cwp:
	@cd lib/CWP/BasicCWP/ ; \
	ruby extconf.rb;\
	make;\
	rm *.o
	
gema_c_capacited_phub:
	@cd lib/PHUB/CapacitedPHubNode/;\
	ruby extconf.rb;\
	make;\
	rm *.o
	
gema_c_basic_phub:
	@cd lib/PHUB/BasicPHub/;\
	ruby extconf.rb;\
	make;\
	rm *.o;
	
clean:
	-cd lib/CWP/BasicCWP/; \
	rm *.so;
	
	-cd lib/PHUB/CapacitedPHubNode/; \
	rm *.so;
	
	-cd lib/PHUB/BasicPHub/;\
	rm *.so;