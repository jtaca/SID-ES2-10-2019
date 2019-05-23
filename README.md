# SID-ES2-10-2019

This repository, is dedicated to the project "Monitorização de Culturas em Laboratório" for the course Distributed Information Systems. The project is being developed according to the Standard Software Engineering principles studyed in Software Engineering I and II.

## Contributing 


The team members are:   
André Silva @TheSilvandre nº77981  .  
Gonçalo Fernandes @gbfso-iscteiul nº73538 .  
João Aparício @jtaca nº77812 .  
João Neto @jfpno-iscteiul nº72809 .  
João Saramago @JoaoSaramago nº77561 .  
Rita Costa @rmsca111-iscteiul nº77778 . 

# Monitorização de Culturas em Laboratório

## Install Instructions  
### Install Virtual box 
Instalar virtual box (link)[https://www.virtualbox.org/wiki/Downloads]

Correr powershell como administrador:

 Fazer disable Hyper-V com o segunte comando: bcdedit /set hypervisorlaunchtype off

Deve fazer restart do seu PC.

(To turn Hyper-V back on, run the command: bcdedit /set hypervisorlaunchtype auto)

Deve agora executar a o ficheiro "MSEdge - Win10.ova" e iniciar a maquina virtual associada.

### Iniciar o MongoDB e XAMPP

Para começar o servidor da Base de dados:
Correr como administrador uma unstância do cmd.exe (disponivel no desktop)
e correr: 

net start MongoDB

(para parar: net stop MongoDB)

Para executar o servidor de bases de dados relacional inicie o XAMPP ( no desktop)
e corra os serviços: Apache e MySQL.

### Iniciar aplicação desktop do administrador e do investigador


Para começar a corre a aplicação do Investigador ou administrador execute o IteliJ (no desktop) e execute o projeto simplesmente.

(nós geramos diversas versões dos jar independentes do ambiente de desenvolvimeto, mas todos tinham bugs associados, por isso acabamos por fazer a entrega assim. Não é de facto adequado para entregar ao cliente final, mas não foi falta de tentar)


Para aceder aos dados no Android, deve ativar a função de shared drag and drop (Menu da VM: Devices > Drag and Drop > Guest to Host). Copie o .apk para o seu desktop e descarregue no seu smartphone (Android inferior a 9.0).  

Agora deve de verificar que o depuramento USB está ligado abrir a aplicação com um gestor de ficheiros e executa-la. (Caso não esteja deve ligalo através do debug mode do android, e quando conectar o disposivo à sua workstation, deverá haver uma notificação que premite fazer essa opção).

De seguida abra uma nova instância do CMD.exe (no desktop) e insira: ipconfig. Deve ter acesso ao seu endereço de IP (2 linha, geralmente diz IPV4). 
Agora copie o endereço de IP para as credenciais correspondentes no seu dispositivo movel. os restantes campos devem ser:






    
    Para iniciar a interface do auditor, acesse através do edge a localhost/PHP_Migration/guiAuditor.php
    
    
        
	Obrigado pela sua colaboração. 
	Se encontrar algum bug associado à implementação, não hexite em contactar-nos.


### Printscreens

#### LabClient

![Web_1366_–_1](https://user-images.githubusercontent.com/26983006/57474830-f56b1600-728a-11e9-8d3d-be5cb239566d.png)

#### AndroidClient

To install the android app, you have to copy the .apk generated [here](https://github.com/jtaca/SID-ES2-10-2019/blob/master/AppAndroid/SID2019/app/release/app-release.apk) and install it on your android smartphone.

![Login2](https://user-images.githubusercontent.com/26983006/57474327-c902ca00-7289-11e9-9534-08a53aeb5510.jpg)

![ComboBox](https://user-images.githubusercontent.com/26983006/57474418-f0f22d80-7289-11e9-8522-0146b76ffb2d.jpg)

![Principal com dados](https://user-images.githubusercontent.com/26983006/57474469-08c9b180-728a-11e9-820e-4e1111b642b1.jpg)

![Calendario](https://user-images.githubusercontent.com/26983006/57474607-6958ee80-728a-11e9-8317-175eaea2d717.jpg)

![Alertas Globais](https://user-images.githubusercontent.com/26983006/57474519-28f97080-728a-11e9-9fe3-80039e12b598.jpg)

![Graficos sem dados](https://user-images.githubusercontent.com/26983006/57474563-4dede380-728a-11e9-8c49-b71d529a984a.jpg)
	
