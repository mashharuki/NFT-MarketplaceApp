const { assert } = require('chai');

const KryptoBird = artifacts.require('./Kryptobirdz');

// check chai
require('chai')
      .use(require('chai-as-promised'))
      .should()

contract('KryotoBird', (accounts) => {
      let contract;

      describe('deployment', async() => {
            it('deploys successfuly', async() => {
                  contract = await KryptoBird.deployed();
                  const address = contract.address;
                  assert.notEqual(address, '');
                  assert.notEqual(address, null);
                  assert.notEqual(address, undefined);
                  assert.notEqual(address, 0x0);
            });
      });
});