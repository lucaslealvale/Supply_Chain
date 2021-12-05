# @version ^0.2.0


# Struct que agrupa os dados de uma doacao
struct Donation:
    date: uint256 # Data da doacao
    id_: uint256 # ID da doacao
    available: bool # Status da doacao
    

struct Plaqueta:
    id_: uint256 # ID da doacao
    idP: uint256 # ID da Plaqueta
    date: uint256 # Data da doacao
    available: bool # Status da doacao
    
nextAvailablePlaqueta : uint256
plaquetaCounter: uint256
supplyCounter: uint256
nextDonationAnalisys : uint256

# Dicionário que indica se o usuário fez uma doacao
donations: public(HashMap[uint256, Donation])

plaquetas: public(HashMap[uint256, Plaqueta])


# Função que roda quando é feito o deploy do contrato
@external
def __init__():
    # Guarda o Endereço do dono do contrato na variável
    self.nextAvailablePlaqueta = 1
    self.plaquetaCounter = 0
    self.supplyCounter = 0
    self.nextDonationAnalisys = 1

    
@external # Habilita para interação externa (função chamável)
def donateBlood():
    # # Testa se o evento ainda não acabou
    # assert block.timestamp < self.deadLine, "Crowdfunding has finished"
    # assert self.end == False, "Crowdfunding has finished"

    self.supplyCounter += 1  # Incrementa a quantidade total das doacoes

    # adiciona o valor da doacao atual
    self.donations[self.supplyCounter] =  Donation({
        date : block.timestamp,
        id_ : self.supplyCounter,
        available: False,
        })

# Função para atualizar status da doação de sangue
@external # Habilita para interação externa (função chamável)
@payable
def labResults():  
    assert msg.value == 0 or msg.value == 1, "Invalid value"
    # funcionario pega o resultado e atualiza o status da doação
    # se o resultado for positivo, adiciona no struct
    
    assert self.nextDonationAnalisys <= self.supplyCounter, "Donation not found" 
   # insere o resulto do exame laboratorial
    if(msg.value == 1):
        self.donations[self.nextDonationAnalisys] =  Donation({
            date : block.timestamp,
            id_ : self.nextDonationAnalisys,
            available: True,
            })
        # Cria uma nova plaqueta:
        self.plaquetaCounter += 1
        self.plaquetas[self.plaquetaCounter] =  Plaqueta({
            id_ : self.nextDonationAnalisys,
            idP : self.plaquetaCounter,
            date: self.donations[self.nextDonationAnalisys].date,
            available: True,
            })


    elif(msg.value ==0):    
        self.donations[self.supplyCounter] =  Donation({
            date : block.timestamp,
            id_ : self.supplyCounter,
            available: False,
            })

    self.nextDonationAnalisys += 1

# Funcao para a retirada da plaqueta
@external
def getPlaqueta():
    assert self.nextAvailablePlaqueta <= self.plaquetaCounter, "Plaqueta not found"

    assert block.timestamp < self.plaquetas[self.nextAvailablePlaqueta].date * 10 , "Plaqueta expired"
    # Se a plaqueta estiver disponivel, consome e torna-se indisponivel
    auxId_ : uint256 = self.plaquetas[self.nextAvailablePlaqueta].id_
    auxDate : uint256 = self.plaquetas[self.nextAvailablePlaqueta].date

    self.plaquetas[self.nextAvailablePlaqueta] =  Plaqueta({
            id_ : auxId_,
            idP : self.nextAvailablePlaqueta,
            date: auxDate,
            available: False,
        })

    self.nextAvailablePlaqueta += 1

# # Função que encerra o evento
# @external
# def finish():
#     # Caso o evento já tenha terminado
#     assert self.end == False, "Crowdfunding already finished"

#     # # Testa se o evento já foi encerrado (passou a data limite)
#     # assert block.timestamp > self.deadLine, "Crowdfunding still in progress"

#     # Testa se é o dono do contrato
#     assert msg.sender == self.owner, "Only the owner can finish the event"
    
#     # Testa se o evento alcançou o minimo de doacao
#     assert self.count >= self.priceGoal, "Not reached the goal"

#     # Sinaliza e saca o dinheiro do contrato
#     self.end = True
#     selfdestruct(msg.sender)


# # Função para pedir refound de uma doacao caso a meta não tenha sido atingida
# @external
# def refound():
#     # Checa se o evento acabou
#     assert block.timestamp > self.deadLine, "Crowdfunding still in progress"

#     # Testa se o evento acabou sem bater a meta
#     assert self.count <= self.priceGoal, "We reached the goal"

#     # Chega se o msg.value é menor ou igual ao valor que a pessoa doou

#     # # Checa se o msg.sender fez uma doacao e se ela é valida para retirada
#     assert self.users[msg.sender].price > 0, "You don't have anything to withdraw"

#     # Transfere o dinheiro para a pessoa
#     send(msg.sender, self.users[msg.sender].price)
#     # self.users[msg.sender].valid = False
    
