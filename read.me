1. Em qual camada foi implementado o mecanismo de cache? Explique por que essa decisão é adequada dentro da arquitetura proposta.
O cache foi orquestrado no Repositório, que decide quando usar dados locais, quando buscar no remoto e como fazer fallback, enquanto o armazenamento físico ficou no DataSource local com SharedPreferences, essa divisão mantém a regra de seleção de fonte no Repositório e limita o DataSource a operações de IO, deixando UI e ViewModel livres de detalhes de infraestrutura.

2. Por que o ViewModel não deve realizar chamadas HTTP diretamente?
Porque o papel do ViewModel é coordenar estado e lógica de apresentação, ao depender do Repositório ele fica mais testável com dublês, reduz acoplamento com rede e permite trocar a origem dos dados sem alterar a UI.

3. O que poderia acontecer se a interface acessasse diretamente o DataSource?
Haveria acoplamento com infraestrutura, repetição de lógica de cache e tratamento de erros na própria tela, manutenção mais difícil e quebra do princípio de camadas.

4. Como essa arquitetura facilitaria a substituição da API por um banco de dados local?
A UI e o ViewModel permanecem iguais, basta introduzir um DataSource de banco e ajustar o Repositório para decidir entre banco e cache, a mudança fica localizada e transparente para as camadas superiores.
