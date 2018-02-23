##########################################################################
# Script para predição de eventos críticos em dados médicos
##########################################################################

# Argumentos:
#'    @param caminhoArq Caminho do arquivo que contém os dados médicos. Ex.: /home/paciente465-HRs.csv
#'    @param tamArq Número de linhas do arquivo (tamanho eixo x do plot dos dados). Ex.: 30000
#'    @param nLin Número de linhas para realizar os plots e análises. Ex.: 850
#'    @param valSkip Número de linhas que deve pular em cada leitura do arquivo. Ex.: 0
#'    @param somaSkip Número de linhas que deve pular (é o mesmo valor usado no nLin). Ex.: 850
#'
#'--------------------------------------------------------------------
#' Leitura dados /paciente472-HR 
#' Aplicação de indicadores genéricos para fenômeno de critical slowing down
#' --------------------------------------------------------------------

predict_event <- function(caminhoArq, tamArq, nLin, valSkip, somaSkip){
  
  library(devtools)
  library(earlywarnings)
  
  val = tamArq / nLin # numero de vezes que tera que ler o arquivo
  
  for (val in 0:val){
    
    arq <- read.csv(caminhoArq, header = TRUE, sep = ",", dec = ".",col.names=c('tempo','sinal'), nrows = nLin, skip = valSkip)
    
    # plot(arq, type="l", main="Transição Crítica", xlab="Tempo (s)", ylab="Sinais Vitais Respiratórios")
    
    generic_ews(arq, winsize = 50, detrending = 'gaussian', bandwidth = 10)
    
    valSkip = valSkip + somaSkip
  }
  
}

#predict_event("/home/andressa/R/earlywarnings-R-master/DADOS/DadosMIMIC/paciente465-HRs.csv", 35000, 1000, 0, 1000)

predict_event("/home/andressa/R/earlywarnings-R-master/DADOS/DadosMIMIC/paciente472-HR.csv", 30000, 850, 0, 850)