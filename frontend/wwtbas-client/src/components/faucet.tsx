import { getFaucetHost, requestSuiFromFaucetV2 } from "@mysten/sui/faucet";
import { useEffect } from "react";

const Faucet = () => {
    useEffect(() => {
        async function FetchFaucet(){
            await requestSuiFromFaucetV2({
                host: getFaucetHost('testnet'),
                recipient: '0x7a26fe751dbdc0f43e63a51712738241ef7f91e6e9a8a256a958ebd3d565b27e'
            })
        }
    })
}

   