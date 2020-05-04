# Openstack-5_nodes-Cloud

Creación de una estructura cloud basada en 5 nodos y bajo un entorno Openstack. Los archivos proporcionados son: 


-	hosts: archivo para que cada máquina reconozca al resto 

-	99-openstack: archivo de configuración relacionado con la bbdd. 

-	admin-openrc y demo-openrc: cuentas administrativas por defecto 

-	Vagrantfile: archivo de configuración para la creación de los nodos 

-	openstack.sh: script de ejecución de la instalación 

-	basic_provision: carpeta con la instalación de chrony para cada nodo 

-	openstack_services: carpeta con la instalación de cada uno de los servicios.


Mediante la creación de un directorio bajo el que albergar el archivo de configuración Vagrantfile y la ejecución del comando vagrant up crearemos el sistema de cinco máquinas virtuales.

Tras esto, el script openstack.sh se encargará de instalar todos los servicios básicos y avanzados, salvo backup. Es conveniente revisar el script para colocar la ruta más adecuada a las necesidades. La instalación automática de todos los servicios podría llevar un par de horas. Para un mejor seguimiento de este proceso, consultar el TFG de Yahia Rebah Bouaiachi, Universidad Autónoma de Madrid.
