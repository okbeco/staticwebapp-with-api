// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CarbonCreditsContract {
    // Estrutura para representar os créditos de carbono
    struct CarbonCredit {
        address owner; // Endereço do proprietário do crédito
        uint256 amount; // Quantidade de créditos disponíveis para venda
        uint256 price; // Preço do crédito em ether (ou outra criptomoeda)
        bool isAvailable; // Indica se os créditos estão disponíveis para venda
    }

    mapping(address => CarbonCredit) public carbonCredits; // Mapeamento dos créditos de carbono por endereço do proprietário

    // Eventos para notificar alterações no contrato
    event CreditRegistered(address indexed owner, uint256 amount, uint256 price);
    event CreditPurchased(address indexed owner, address indexed buyer, uint256 amount, uint256 price);

    // Função para registrar os créditos de carbono disponíveis para venda
    function registerCredit(uint256 _amount, uint256 _price) external {
        require(_amount > 0, "Amount must be greater than zero");
        require(_price > 0, "Price must be greater than zero");

        CarbonCredit storage credit = carbonCredits[msg.sender];
        require(!credit.isAvailable, "Credit already registered");

        credit.owner = msg.sender;
        credit.amount = _amount;
        credit.price = _price;
        credit.isAvailable = true;

        emit CreditRegistered(msg.sender, _amount, _price);
    }

    // Função para comprar créditos de carbono
    function purchaseCredit(address _owner) external payable {
        CarbonCredit storage credit = carbonCredits[_owner];
        require(credit.isAvailable, "Credit not available for purchase");
        require(msg.value >= credit.price, "Insufficient funds");

        credit.owner = msg.sender;
        credit.isAvailable = false;

        emit CreditPurchased(_owner, msg.sender, credit.amount, credit.price);

        // Transferir os fundos para o vendedor
        payable(_owner).transfer(msg.value);
    }
}
