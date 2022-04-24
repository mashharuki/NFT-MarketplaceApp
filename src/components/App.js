import React, { Component } from "react";
import Web3 from "web3";
import detectEthereumProvider from "@metamask/detect-provider";
import KryptoBird from "./../abis/Kryptobirdz.json";

/**
 * Appコンポーネント
 */
class App extends Component {

      // レンダリング後に実行する関数
      async componentDidMount() {
            await this.loadWeb3();
            await this.loadBlockchainData();
      }

      // コンストラクター
      constructor(props) {
            super(props);
            // ステート変数
            this.state = {
                  account: '',
                  contract: null,
                  totalSupply: 0,
                  kryptoBirdz: [],
            }
      }

      // メタマスクに接続する。
      async loadWeb3() {
            const provider = await detectEthereumProvider();

            if(provider) {
                  console.log("ethereum wallet is connected");
                  window.web3 = new Web3(provider);
            } else {
                  console.log("no ethereum wallet detected");
            }
      }

      // アカウント情報を読み取る関数
      async loadBlockchainData() {
            const web3 =  window.web3;
            // アカウント情報
            const accounts = await web3.eth.getAccounts();
            this.setState({account: accounts[0]});
            console.log("accounts", this.state.account);

            const networkId = await web3.eth.net.getId();
            const networkData = KryptoBird.networks[networkId];
            // コントラクトのnetworkデータが存在すれば
            if(networkData) {
                  const abi = KryptoBird.abi;
                  const address = networkData.address
                  const contract = new web3.eth.Contract(abi, address);
                  this.setState({contract: contract});
                  // 総供給量を取得する。
                  const totalSupply = await contract.methods.totalSupply().call();
                  this.setState({totalSupply: totalSupply});
                  console.log("totalsupply:", this.state.totalSupply);

                  for(let i = 1; i <= totalSupply; i++) {
                        const KryptoBird = await contract.methods.KryptoBirdz(i - 1).call;
                        this.setState({
                              kryptoBirdz:[...this.state.kryptoBirdz, KryptoBird]
                        });
                  }
                  console.log('kryptoBirdz:', this.state.kryptoBirdz);
            } else {
                  window.alert('Smart contract not deployed')
            }
      }

      // mint関数
      mint = (kryptoBird) => {
            this.state.contract.methods
                  .mint(kryptoBird)
                  .send({from: this.state.account})
                  .once('receipt', (receipt) => {
                        this.setState({
                              kryptoBirdz:[...this.state.kryptoBirdz, KryptoBird]
                        });
                  });

      };
      
      render() {
            return(
                  <div>
                        {console.log(this.state.kryptoBirdz)}
                        <nav className="navbar navbar-dark fixed-top bg-dark flex-md-nowrap p-0 shodow">
                              <div className="navbar-brand col-sm-3 col-md-3 mr-0" style={{color: 'white'}}>
                                    Krypto Birdz NFTs (Non Fungible Tokens)
                              </div>
                              <ul className="navbar-nav px-3">
                                    <li className="nav-item text-nowrap d-none d-sm-none d-sm-block">
                                          <small className="text-white">
                                                {this.state.account}
                                          </small>
                                    </li>
                              </ul>
                        </nav>
                        <div className="container-fluid mt-1">
                              <div className="row">
                                    <main role="main" className="col-lg-12 d-flex text-center">
                                          <div className="content mr-auto ml-auto" style={{opacity: '0.8'}}>
                                                <h1 style={{color: 'white'}}>
                                                      Kryptobirdz - NFT Marketplace
                                                </h1>
                                                <form onSubmit={(event) => {
                                                      event.preventDefault();
                                                      const kryptoBird = this.kryptoBird.value;
                                                      this.mint(kryptoBird);
                                                }}>
                                                      <input 
                                                            type="text" 
                                                            name="text" 
                                                            className="form-control mb-1" 
                                                            placeholder="add file location"
                                                            ref={(input) => this.kryptoBird = input}
                                                            />
                                                      <input type="submit" style={{margin: '6px'}} className="btn btn-primary btn-black" value="mint"/>
                                                </form>
                                          </div>
                                    </main>
                              </div>
                        </div>
                  </div>
            )
      }
}

export default App;