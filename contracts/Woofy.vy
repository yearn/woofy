# @version 0.2.12
from vyper.interfaces import ERC20

implements: ERC20

event Transfer:
    sender: indexed(address)
    receiver: indexed(address)
    value: uint256


event Approval:
    owner: indexed(address)
    spender: indexed(address)
    value: uint256


allowance: public(HashMap[address, HashMap[address, uint256]])
balanceOf: public(HashMap[address, uint256])
totalSupply: public(uint256)

yfi: public(ERC20)


@external
def __init__():
    self.yfi = ERC20(0x0bc529c00C6401aEF6D220BE8C6Ea1667F6Ad93e)


@view
@external
def name() -> String[5]:
    return "Woofy"


@view
@external
def symbol() -> String[5]:
    return "WOOFY"


@view
@external
def decimals() -> uint256:
    return 9


@internal
def _mint(receiver: address, amount: uint256):
    assert not receiver in [self, ZERO_ADDRESS]

    self.balanceOf[receiver] += amount
    self.totalSupply += amount

    log Transfer(ZERO_ADDRESS, receiver, amount)


@internal
def _burn(sender: address, amount: uint256):
    self.balanceOf[sender] -= amount
    self.totalSupply -= amount

    log Transfer(sender, ZERO_ADDRESS, amount)


@internal
def _transfer(sender: address, receiver: address, amount: uint256):
    assert not receiver in [self, ZERO_ADDRESS]

    self.balanceOf[sender] -= amount
    self.balanceOf[receiver] += amount

    log Transfer(sender, receiver, amount)


@external
def transfer(receiver: address, amount: uint256) -> bool:
    self._transfer(msg.sender, receiver, amount)
    return True


@external
def transferFrom(sender: address, receiver: address, amount: uint256) -> bool:
    self.allowance[sender][msg.sender] -= amount
    self._transfer(sender, receiver, amount)
    return True


@external
def approve(spender: address, amount: uint256) -> bool:
    self.allowance[msg.sender][spender] = amount
    log Approval(msg.sender, spender, amount)
    return True


@external
def deposit(amount: uint256 = MAX_UINT256) -> bool:
    mint_amount: uint256 = min(amount, self.yfi.balanceOf(msg.sender))
    assert self.yfi.transferFrom(msg.sender, self, mint_amount)
    self._mint(msg.sender, mint_amount)
    return True


@external
def withdraw(amount: uint256 = MAX_UINT256) -> bool:
    burn_amount: uint256 = min(amount, self.balanceOf[msg.sender])
    self._burn(msg.sender, burn_amount)
    assert self.yfi.transfer(msg.sender, burn_amount)
    return True
