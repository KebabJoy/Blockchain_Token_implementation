// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract DeadInsideToken {
    // Переменная token_name хранит азвание нашего токена
    string public constant token_name = "Dead Inside Token";

    /* Переменная token_symbol хранит сокращение названия нашего токена
    С этим символом ваша валюта будет отображаться на биржах и в кошельках. */
    string public constant token_symbol = "DIT";
    
    // Насколько дробится ваш токен
    uint8 public constant token_decimals = 6;

    // Общее количество токенов
    uint256 private token_totalSupply = 1000000;

    // Маппинг балансов адресов
    mapping (address => uint) public balances;

    /* Первый ключ — адрес на снятие с которого предоставляется разрешение. 
    Второй ключ — пользователь, которому предоставляется разрешение. */
    mapping (address => mapping (address => uint)) allowed;

    // Проверям чтобы у пользователя хватало денег и значение _value не было отрицательным
    modifier notEnoughMoney(uint _value){
        require(
            _value >= 0,
            "Value is negative"
        );

        require(
            _value < balanceOf(msg.sender),
            "Your don't have enough money :("
        );
        _;
    }

    //Проверяем разрешение на перевод средств у кошельков
    modifier permission(address _from, address _to, uint256 _value) {
        require(
            allowed[_from][_to] >= _value,
            "You don't have permission to use this function"
        );
        _;
    } 

    /* Модификатор видимости public в новых версиях здесь не нужен
    но тк мы используем старую версию трафла, то нужно прописывать его, хотя, он будет попросту игнорироваться */
    constructor() public {
        balances[msg.sender] = token_totalSupply;
    }

    // OPTIONAL - This method can be used to improve usability, but interfaces and other contracts MUST NOT expect these values to be present.
    function name() public view returns (string memory) {
        return token_name;
    }

    // OPTIONAL - This method can be used to improve usability, but interfaces and other contracts MUST NOT expect these values to be present.
    function symbol() public view returns (string memory) {
        return token_name;
    }

    // OPTIONAL - This method can be used to improve usability, but interfaces and other contracts MUST NOT expect these values to be present.
    function decimals() public view returns (uint8) {
        return token_decimals;
    }

    // Returns the total token supply.
    function totalSupply() public view returns (uint256) {
        return token_totalSupply;
    }

    // Returns the account balance of another account with address _owner.
    function balanceOf(address _owner) public view returns (uint256 balance) {
        return balances[_owner];
    }

    // msg.sender отправляет _value токенов на адрес _to
    function transfer(address _to, uint256 _value) public notEnoughMoney(_value) returns (bool success) {
        balances[_to] += _value;
        balances[msg.sender] -= _value;  
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    /* Передает _ value монет от _from к _to. 
    Пользователь должен иметь разрешение на перемещение монеток между адресами, дабы любой желающий не смог управлять чужими кошельками. 
    Фактически эта функция позволяет вашему доверенному лицу распоряжаться определенным объемом монеток на вашем счету */ 
    function transferFrom(address _from, address _to, uint256 _value) public notEnoughMoney(_value) permission(_from, _to, _value) returns (bool success) {
        uint previousBalances = balanceOf(_from) + balanceOf(_to);
        balances[_from] -= _value; 
        balances[_to] += _value;
        emit Transfer(_from, _to, _value);
        assert(previousBalances == balanceOf(_from) + balanceOf(_to));
        return true;
    }

    // Разрешает пользователю _spender снимать с вашего счета (точнее со счета вызвавшего функцию пользователя) средства не более чем _value.
    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    // Возвращает сколько монет со своего счета разрешил снимать пользователь _owner пользователю _spender.
    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }

    event Transfer(address indexed _from, address indexed _to, uint _value);
    
    event Approval(address indexed _owner, address indexed _spender, uint _value);
}
