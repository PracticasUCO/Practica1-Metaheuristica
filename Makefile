.PHONY: clean gemas
# El siguiente makefile se asegura de que las gemas estan compiladas
# de manera que haya problemas al tratar de ejecutar practica 1

all: gemas
gemas: gema_c_basic_cwp gema_c_capacited_phub
	@echo "Gemas compiladas correctamente"
	
gema_c_basic_cwp:
	@cd class/CWP/ ; \
	echo "Creando makefile para la gema c_basic_cwp...";\
	ruby extconf.rb;\
	echo "Compilando gema...";\
	make;\
	echo "Borrando objetos...";\
	rm *.o
	
gema_c_capacited_phub:
	@cd class/PHUB/;\
	echo "Creando makefile para la gema c_capacited_phub";\
	ruby extconf.rb;\
	echo "Compilando gema...";\
	make;\
	echo "Borrando objetos...";\
	rm *.o
	
clean:
	-@cd class/CWP/; \
	rm *.so;
	
	-@cd class/PHUB/; \
	rm *.so;