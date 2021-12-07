# Supply_Chain
Projeto de Block Chain para implementação de uma supply chain para doação de sangue.  
Feito em Vyper e baseado nas aulas de Ativos Digitais por Raul Ikeda.  
Neste contrato o dono é capaz de adicionar doações de sangue no banco e realizar os testes laboratoriais gerando um resultado resultado positivo para a doação apontada, por meio do seu id.  
Uma vez que os teste laboratoriais validaram uma doação, surgem então três hemo-componentes no banco, que são:
  
Plaquetas  
Hemacias  
Plasma  
  
O administrador da blockchain tem poder de realizar a retirada de cada um desses componentes desde que eles estejam dentro do prazo de validade.  
Para utilizar/testar este contrato é possível compila-lo pelo site https://remix.ethereum.org/ e executa-lo pelo mesmo site.  
