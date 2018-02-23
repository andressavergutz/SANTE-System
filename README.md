# SANTE-System

O sistema SANTE foi criado durante o mestrado. 

Ele engloba as redes híbiridas WBAN (IEEE 802.15.6) e WLAN (IEEE 802.11e).

Seu objetivo é predizer eventos críticos na saúde de pacientes (ex. ataques cardíacos e paradas respiratórias) nas redes WBAN e transmitir prioritariamente alertas médicos para os profissionais da saúde. Esse alerta médico passa por diferentes redes e tecnologias para chegar até seu destino final. Por isso, para enviar os alertas com o mínimo de perda e atraso, criamos uma categoria de acesso exclusiva para os alertas médicos no padrão IEEE 802.11e. 

Dessa forma, temos duas fases dentro do sistema SANTE:
1 - Predição de eventos críticos na saúde de pacientes
2 - Transmissão prioritária de alertas médicos

(Abaixo essas fases são descritas, bem como suas dependências e códigos ... )


1 - Predição de eventos críticos na saúde de pacientes

Ferramenta: R (análises estatísticas)

Biblioteca: Early warning signal toolbox (EWS - http://www.early-warning-signals.org/). Essa biblioteca é usada para a predição. Ela possui indicadores estatísticos que apresentam comportamentos genéricos a medida que um evento crítico se aproxima da condição de saúde do paciente.

Dados sobre sinais vitais: a predição utiliza dados vitais de pacientes que foram monitorados em hospitais (na prática esses dados serão coletados pelos sensores corporais das WBANs, mas para a fase de testes usamos a base de dados online MIMIC II do PhysionetBank). Usamos dados de frequência respiratória de um paciente masculino com 70 anos de idade com edema pulmonar. 

O subdiretório R-analysis possui os códigos da fase de predição:
- script-prediction.R : utiliza os dados vitais de entrada e realiza a predição por meio da biblioteca EWS
- resuls-kendall.csv : exemplo de saída da predição (os resultados de cada indicador da biblioteca EWS geram um valor de kendall tau, esse valor é armazenado para servir de entrada para as simulações no NS-3)

Quando identificamos um comportamento genérico dos indicadores no R, geramos alertas médicos. Para testar a transmissão prioritária do alerta, criamos um ambiente de simulação no NS3...


2 - Transmissão prioritária de alertas médicos

Ferramenta: NS-3

Módulo usado no NS-3: IEEE 802.11

Aplicação usada no NS-3: OnOff Application

Dados de entrada: resuls-kendall.csv

O subdiretório NS3-simulation possui os códigos da fase de transmissão:
- cenariowbanv3-21_12.cc : possui todo o código de simulação, englobando a criação da categoria de acesso exclusiva para os alertas médicos no 802.11, o mapeamento prioritário, a geração dos alertas e de outros fluxos de dados para causar competição de acesso ao meio.
- onoff-application-19_12.cc / onoff-application-19_12.h: aplicação usada para geração de fluxo de dados. Foi alterada em algumas partes, por isso estou disponibilizando o código.


OBS.: após executar simulações no NS-3, arquivos de saída são gerados. Com base nesses arquivos, o script sbrc2017v1.sh gera os plots de taxa de perda de pacotes e atraso médio no envio dos pacotes. A geração dos plots utiliza gnuplot.



