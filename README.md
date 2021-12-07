# Supply_Chain
Projeto de Block Chain para implementação de uma supply chain para doação de sangue.  
Feito em Vyper e baseado nas aulas de Ativos Digitais por Raul Ikeda.  
Neste contrato o dono é capaz de adicionar doações de sangue no banco e realizar os testes laboratoriais gerando um resultado resultado positivo para a doação apontada, por meio do seu id.  
Uma vez que os teste laboratoriais validaram uma doação, surgem então três hemo-componentes no banco, que são:
  
Plaquetas  
Hemacias  
Plasma  
  
O administrador da blockchain, correspondente ao banco de sangue, tem poder de realizar doação e retirar de cada um desses componentes desde que eles estejam dentro do prazo de validade. Os hospitais parceiros adicionados na rede são capazes de efetivar doações ao banco e de retirar hemocomponentes, contudo não tem poder de realizar os testes laboratoriais, uma vez que estes estão centralizados no banco.   
Para utilizar/testar este contrato é possível compila-lo pelo site https://remix.ethereum.org/ e executa-lo pelo mesmo site.  
