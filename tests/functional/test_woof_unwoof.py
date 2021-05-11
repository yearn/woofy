def test_woof(wifey, woofy, user):
    assert woofy.totalSupply() == 0

    amount = 10 ** 18
    before = wifey.balanceOf(user)

    wifey.approve(woofy, amount)
    woofy.woof(amount)

    assert wifey.balanceOf(user) == before - amount
    assert woofy.balanceOf(user) == amount
    assert woofy.totalSupply() == amount

    woofy.unwoof()

    assert wifey.balanceOf(user) == before
    assert woofy.balanceOf(user) == 0
    assert woofy.totalSupply() == 0
