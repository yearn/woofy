import pytest

# Function scoped isolation fixture to enable xdist.
# Snapshots the chain before each test and reverts after test completion.
@pytest.fixture(scope="function", autouse=True)
def shared_setup(fn_isolation):
    pass


@pytest.fixture()
def user(accounts):
    return accounts.at("0x3ff33d9162aD47660083D7DC4bC02Fb231c81677", force=True)


@pytest.fixture()
def woofy(Woofy, user):
    return Woofy.deploy({"from": user})


@pytest.fixture()
def wifey(user, interface, woofy):
    return interface.ERC20("0x0bc529c00C6401aEF6D220BE8C6Ea1667F6Ad93e", owner=user)
