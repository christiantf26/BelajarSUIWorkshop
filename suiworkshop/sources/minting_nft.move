module suiworkshop::minting_nft {
    use sui::object::{Self, UID};
    use sui::transfer;
    use sui::tx_context::TxContext;
    use std::string;
    use sui::url;
    use sui::event;

    /// NFT struct definition
    public struct TestnetNFT has key, store {
        id: UID,
        name: string::String,
        description: string::String,
        url: url::Url,
    }

    /// Event untuk NFT yang di-mint
    public struct NFTMinted has copy, drop {
        object_id: object::ID,
        creator: address,
        name: string::String,
    }
#[allow(lint(self_transfer))]
    public fun mint_to_sender(
        name: vector<u8>,
        description: vector<u8>,
        url: vector<u8>,
        ctx: &mut TxContext,
    ) {
        let sender = ctx.sender();
        let nft = TestnetNFT {
            id: object::new(ctx),
            name: string::utf8(name),
            description: string::utf8(description),
            url: url::new_unsafe_from_bytes(url),
        };

        event::emit(NFTMinted {
            object_id: object::id(&nft),
            creator: sender,
            name: nft.name,
        });

        transfer::public_transfer(nft, sender);
    }
}