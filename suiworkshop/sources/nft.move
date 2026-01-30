module suiworkshop::minting_nft{
    use std::string::String;
    use sui::url::new_unsafe_from_bytes;
    use sui::url::{Self, Url};
    use std::string;
    use sui::event;


    // inisialisasi struct dengan keywrod key (memperbolehkan struct menjadi object) dan store
    // (memperbolehkan dia untuk di store ke storage)
    public struct TestnetNFT has key, store {
        id : UID,
        name : string::String,
        description : string::String,
        url : Url,
    }

    public struct NFTMinted has copy,drop{
        object_id : ID,
        creator : address,
        name : string::String
    }

// untuk ngemint nft ke sendernya
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
        event::emit(NFTMinted{
            object_id : object::id(&nft),
            creator : sender,
            name : nft.name
        });
        transfer::public_transfer(nft,sender);

    }
    // untuk ngetransfer NFT yang ada di wallet kita, ke wallet orang lain
    public fun transfer(nft : TestnetNFT, recipient :address, _: &mut TxContext){
        transfer::public_transfer(nft, recipient);
    }
}


// For Move coding conventions, see
// https://docs.sui.io/concepts/sui-move-concepts/conventions