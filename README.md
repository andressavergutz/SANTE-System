# SANTE-System

O sistema SANTE engloba as redes híbiridas WBANs (IEEE 802.15.6) e WLANs (IEEE 802.11e).

Seu objetivo é predizer eventos críticos na saúde de pacientes (ex. ataques cardíacos e paradas respiratórias) e transmitir prioritariamente alertas médicos para os profissionais da saúde. Esse alerta médico passa por diferentes redes e tecnologias para chegar até o seu destino final. Por isso, para enviar os alertas com o mínimo de perda e atraso possível, criamos uma categoria de acesso exclusiva para os alertas médicos no padrão IEEE 802.11e. 

Dessa forma, temos duas fases dentro do sistema SANTE:

1 - Predição de eventos críticos na saúde de pacientes

2 - Transmissão prioritária de alertas médicos

(Abaixo essas fases são descritas, bem como suas dependências e códigos ... )

**Usamos uma máquina com Ubuntu 16.04 LTS** 

## 1 - Predição de eventos críticos na saúde de pacientes

### Requisitos:

Ferramenta: **R e R-Studio v3.14 (análises estatísticas)**

Biblioteca no R: Early warning signal toolbox ([EWS](http://www.early-warning-signals.org/)). Essa biblioteca é usada para a predição de eventos críticos. Ou seja, ela possui indicadores estatísticos que apresentam comportamentos genéricos a medida que um evento crítico se aproxima da condição de saúde do paciente.

No R-Studio execute o arquivo installation.script.R para instalar as dependências e a EWS. Ou pela linha de comando:
```
Rscript installation.script.R
```

Dados sobre sinais vitais: utilizamos dados de frequência respiratória de um paciente masculino com 70 anos de idade com edema pulmonar. Esses dados podem ser obtidos no [Physionet Bank](https://www.physionet.org/physiobank/database/mimic3wdb/).
Os dados referentes ao paciente que usamos é o 466.

Diretório R-analysis possui os códigos da fase de predição:
- ```script-prediction.R``` : utiliza os dados vitais de entrada e realiza a predição por meio da biblioteca EWS. 
- ```resuls-kendall.csv``` : exemplo de saída da predição (os resultados de cada indicador da biblioteca EWS geram um valor de kendall tau, esse valor é armazenado para servir de entrada para as simulações no NS-3)

Obs.: não esqueça de alterar os caminhos dos diretórios de acordo com a sua máquina.

Quando identificamos um comportamento genérico dos indicadores no R, geramos alertas médicos. Para testar a transmissão prioritária do alerta, criamos um ambiente de simulação no NS3...


## 2 - Transmissão prioritária de alertas médicos

### Requisitos: 

Ferramenta: **NS-3.24.1**

1) Instale as dependências:
```
sudo apt-get install gcc g++ python python-dev mercurial bzr gdb valgrind gsl-bin libgsl0-dev libgsl0ldbl flex bison tcpdump sqlite sqlite3 libsqlite3-dev libxml2 libxml2-dev libgtk2.0-0 libgtk2.0-dev uncrustify doxygen graphviz imagemagick python-pygraphviz python-kiwi python-pygoocanvas libgoocanvas-dev python-pygccxml
```
2) Baixe o pacote do NS3 (https://www.nsnam.org/release/ns-allinone-3.24.1.tar.bz2 ) e descompacte no Desktop.
3) Execute:
```
./build.py
./test.py
./waf –d debug --enable-examples –enable-tests configure
./waf --run scratch/first
```
4) Baixe o mercurial... (dependências)
5) Baixe gnuplot... (dependências)
6) Nossa simulação, adaptando seu código:
    
    Módulo usado no NS-3: IEEE 802.11

    Aplicação usada no NS-3: OnOff Application

    Dados de entrada: ```resuls-kendall.csv```. Salve esse script dentro do diretório scratch do NS3. 

O subdiretório NS3-simulation disponibilizado aqui no GitHub possui os códigos da fase de transmissão (mencionada acima):

6.1) ```cenariowbanv3-21_12.cc```: possui todo o código de simulação, englobando a criação da categoria de acesso exclusiva para os alertas médicos no 802.11, o mapeamento prioritário, a geração dos alertas e de outros fluxos de dados para causar competição de acesso ao meio. Salve esse script dentro do diretório scratch:
```
cd /home/ubuntu/Documentos/ns-allinone-3.24.1/ns-3.24.1/scratch/
```
Altere o caminho do arquivo ```resuls-kendall.csv```:
```
const char* pathArq="/home/ubuntu/Documentos/ns-allinone-3.24.1/ns-3.24.1/results-kendall.csv/"
```

6.2) ```onoff-application-19_12.cc / onoff-application-19_12.h```: aplicação usada para geração de fluxo de dados. Foi alterada em algumas partes, por isso estou disponibilizando o código. Para utilizar esse código, acesse o diretório onde fica o script ```onoff-application.cc```:
```
cd /home/ubuntu/Documentos/ns-allinone-3.24.1/ns-3.24.1/src/applications/model/
```
Substitua todo o código da ```onoff-application.cc``` pelo código do script ```onoff-application-19_12.cc```. Faça isso para o script .h também. Após substituir os códigos tenha certeza que você manteve o nome do script conforme padrão do NS3: ```onoff-application.cc``` e ```onoff-aplication.h```. Caso você alterar o nome do script o NS3 não irá encontrá-lo.

6.3) ```sbrc2017v1.sh```: esse script automatiza a execução da simulação no NS3 e também gera os plots dos gráficos utilizando o gnuplot. Salve esse script dentro do diretório scratch. Altere o caminho NS3_PATH conforme seu Desktop:
```
declare NS3_PATH /home/ubuntu/Documentos/ns-allinone-3.24.1/ns-3.24.1/
```
  Confira se o comando de execução ```./waf --run "scratch/cenariowban3-21_22 \ .. "``` na linha 68 possui o nome correto     ```cenariowban3-21_22```

6.4) Após feita todas as alterações de caminho necessárias, execute:
```
cd /home/ubuntu/Documentos/ns-allinone-3.24.1/ns-3.24.1/
./sbrc2017v2.sh -r
```

Para alterar o seu cenário de simulação, altere os valores das seguintes variáveis conforme você desejar:
```
nRun=35
prioritize=2
nWifi=50
```
Vários arquivos .dat serão gerados com os resultados de simulação conforme o valor do nWifi e tipo de tráfego.

Os resultados obtidos com o SANTE-System foram publicadas em formato de artigo no SBRC 2017. Segue o link do artigo para maiores informações: [artigo SBRC](https://sbrc2017.ufpa.br/downloads/trilha-principal/ST16_02.pdf). Caso você quiser mais detalhes, tem o documento da minha dissertação de mestrado também [aqui](https://acervodigital.ufpr.br/bitstream/handle/1884/47989/R%20-%20D%20-%20ANDRESSA%20VERGUTZ%20.pdf?sequence=1).

Bons testes!




