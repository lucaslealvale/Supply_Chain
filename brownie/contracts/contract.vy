# @version ^0.2.0

# Código feito com base nas aulas de ativos digitais por Raul Ikeda e com auxilio da
# documentação do vyper disponivel em: https://remix-ide.readthedocs.io/en/latest/index.html
# Struct que agrupa os dados de uma doacao
struct Donation:
    date: uint256 # Data da doacao
    id_: uint256 # ID da doacao
    available: bool # Status da doacao
    
supplyCounter: uint256

#Iniciando struct de plaquetas
struct Plaqueta:
    id_: uint256 # ID da doacao
    idP: uint256 # ID da Plaqueta
    date: uint256 # Data da doacao
    available: bool # Status da doacao
    
#Iniciando variaveis de plaquetas
nextAvailablePlaqueta : uint256
plaquetaCounter: uint256
timePlaqueta : uint256

#Iniciando struct de Hemacias
struct Hemacia:
    id_: uint256 # ID da doacao
    idH: uint256 # ID da Plaqueta
    date: uint256 # Data da doacao
    available: bool # Status da doacao

#Iniciando variaveis de hemacias
nextAvailableHemacia : uint256
hemaciaCounter: uint256
timeHemacia: uint256

#Iniciando struct de PLasma
struct Plasma:
    id_: uint256 # ID da doacao
    idP: uint256 # ID da Plaqueta
    date: uint256 # Data da doacao
    available: bool # Status da doacao

#Iniciando variaveis de plasma
nextAvailablePlasma : uint256
plasmaCounter: uint256
timePlasma: uint256

#Struct que agrupa os dados alguem apto a fazer mudanças no sistema
struct Hospital:
    id_ : address # Endereço do hospital

#Dicionário que armazena os endereços dos hospitais
hospitais: public(HashMap[address, Hospital])

# Dicionário que indica se o usuário fez uma doacao
donations: public(HashMap[uint256, Donation])

#Dicionarios de componentes do sangue
plaquetas: public(HashMap[uint256, Plaqueta])
hemacias: public(HashMap[uint256, Hemacia])
plasmas: public(HashMap[uint256, Plasma])


# Endereço do dono do contrato
owner: address

idResult: uint256

# Função que roda quando é feito o deploy do contrato
@external
def __init__():
    # Guarda o Endereço do dono do contrato na variável
    self.owner = msg.sender
    
    self.nextAvailablePlaqueta = 1
    self.plaquetaCounter = 0
    
    self.nextAvailableHemacia = 1
    self.hemaciaCounter = 0

    self.nextAvailablePlasma = 1
    self.plasmaCounter = 0

    self.supplyCounter = 0
    
    self.timePlaqueta = 10 #FIXME: 86400 * 5 # (5 dias)  # editar para implementacao real
    self.timeHemacia =  10 #FIXME: 86400 * 365 # (1 ano) # editar para implementacao real
    self.timePlasma = 10  #FIXME: 86400 * 365 # (1 ano) # editar para implementacao real


@external # Habilita para interação externa (função chamável)
def donateBlood():

    # Testa se é o dono do contrato
    assert msg.sender == self.owner, "Only the owner can add a donation"

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
def labResults(idResult: uint256):  
    # Testa se é o dono do contrato
    assert msg.sender == self.owner, "Only the owner can add a lab result"

    assert self.donations[idResult].id_ == idResult, "Invalid donation id"

    # funcionario pega o resultado e atualiza o status da doação
    # se o resultado for positivo, adiciona no struct
    
    assert self.donations[idResult].available == False, "Result already added"

    auxId_ : uint256 = self.donations[idResult].id_

   # insere o resulto do exame laboratorial
    self.donations[idResult] =  Donation({
        date : block.timestamp,
        id_ : auxId_,
        available: True,
        })
    # Cria uma nova plaqueta, hemacia e plasma:
    self.plaquetaCounter += 1
    self.plaquetas[self.plaquetaCounter] =  Plaqueta({
        id_ : auxId_,
        idP : self.plaquetaCounter,
        date: self.donations[idResult].date,
        available: True,
        })
    self.hemaciaCounter += 1
    self.hemacias[self.hemaciaCounter] =  Hemacia({
        id_ : auxId_,
        idH : self.hemaciaCounter,
        date: self.donations[idResult].date,
        available: True,
        })
    self.plasmaCounter += 1
    self.plasmas[self.plasmaCounter] =  Plasma({
        id_ : auxId_,
        idP : self.plasmaCounter,
        date: self.donations[idResult].date,
        available: True,
        })



# @external # Habilita para interação externa (função chamável)
# def addHospital:
#     assert msg.sender == self.owner, "Only the owner can add a hospital"
   

# Funcao para a retirada da plaqueta
@external
def getPlaqueta():
    # Testa se é o dono do contrato
    assert msg.sender == self.owner, "Only the owner can get donation"
    
    # assert self.nextAvailablePlaqueta <= self.plaquetaCounter, "Plaqueta not found"

    if (block.timestamp > self.plaquetas[self.nextAvailablePlaqueta].date + self.timePlaqueta):
        self.nextAvailablePlaqueta += 1
        assert False == True, "Plaqueta expired, try again"    # Se a plaqueta estiver disponivel, consome e torna-se indisponivel
    
    auxId_ : uint256 = self.plaquetas[self.nextAvailablePlaqueta].id_
    auxDate : uint256 = self.plaquetas[self.nextAvailablePlaqueta].date

    self.plaquetas[self.nextAvailablePlaqueta] =  Plaqueta({
            id_ : auxId_,
            idP : self.nextAvailablePlaqueta,
            date: auxDate,
            available: False,
        })

    self.nextAvailablePlaqueta += 1

# Funcao para a retirada de Hemacia
@external
def getHemacia():
    # Testa se é o dono do contrato
    assert msg.sender == self.owner, "Only the owner can get donation"

    # assert self.nextAvailableHemacia < self.hemaciaCounter, "Hemacia not found"

    if (block.timestamp > self.hemacias[self.nextAvailableHemacia].date + self.timeHemacia):
        self.nextAvailableHemacia += 1
        assert False == True , "Hemacia expired, try again"
        
    # Se a plaqueta estiver disponivel, consome e torna-se indisponivel
    auxId_ : uint256 = self.hemacias[self.nextAvailableHemacia].id_
    auxDate : uint256 = self.hemacias[self.nextAvailableHemacia].date

    self.hemacias[self.nextAvailableHemacia] =  Hemacia({
            id_ : auxId_,
            idH : self.nextAvailableHemacia,
            date: auxDate,
            available: False,
        })

    self.nextAvailableHemacia += 1

# Funcao para a retirada do plasma
@external
def getPlasma():
    # Testa se é o dono do contrato
    assert msg.sender == self.owner, "Only the owner can get donation"

    # assert self.nextAvailablePlasma < self.plasmaCounter, "Plasma not found"

    if (block.timestamp > self.plasmas[self.nextAvailablePlasma].date + self.timePlasma):
        self.nextAvailablePlasma += 1
        assert False == True, "Plasma expired, try again"

    # Se a plasma estiver disponivel, consome e torna-se indisponivel
    auxId_ : uint256 = self.plasmas[self.nextAvailablePlasma].id_
    auxDate : uint256 = self.plasmas[self.nextAvailablePlasma].date

    self.plasmas[self.nextAvailablePlasma] =  Plasma({
            id_ : auxId_,
            idP : self.nextAvailablePlasma,
            date: auxDate,
            available: False,
        })

    self.nextAvailablePlasma += 1
