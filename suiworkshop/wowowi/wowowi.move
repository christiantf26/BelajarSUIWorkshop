/// Implements a coin with unlimited supply. TreasuryCap owner can mint
/// any amount at any time.
///
/// Keep the ability to update Currency metadata, such as name, symbol,
/// description, and icon URL.
module suiworkshoptoken::wowowi;

use sui::coin::{Self, TreasuryCap};
use sui::coin_registry::{Self, CoinRegistry};

const TOTAL_SUPPLY: u64 = 1000000000_000000;

// The type identifier of coin. The coin will have a type
// tag of kind: ⁠ Coin<package_object::wowowi::WOWOWI> ⁠
public struct WOWOWI has key { id: UID }

#[allow(lint(self_transfer))]
/// Creates a new currency. Caller receives TreasuryCap for unlimited minting.
public fun new_currency(registry: &mut CoinRegistry, ctx: &mut TxContext) {
    let (currency, treasury_cap) = coin_registry::new_currency<WOWOWI>(
        registry,
        6, // Decimals
        b"WOWOWI".to_string(), // Symbol
        b"WOWOWI".to_string(), // Name
        b"YO WAKARANAI KOK TANYA WATASHI".to_string(), // Description
        b"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQh1cpBR8d2D2P55Z2kQzlr6uGuhRfWzEnoVQ&s".to_string(), // Icon URL
        ctx,
    );

    // Transfer caps to caller for future use
    let metadata_cap = currency.finalize(ctx);
    transfer::public_transfer(metadata_cap, ctx.sender());
    transfer::public_transfer(treasury_cap, ctx.sender());
}

/// Mint any amount of tokens to any address (requires TreasuryCap ownership)
public fun mint(
    treasury_cap: &mut TreasuryCap<WOWOWI>,
    amount: u64,
    recipient: address,
    ctx: &mut TxContext,
) {
    let coin = coin::mint(treasury_cap, amount, ctx);
    transfer::public_transfer(coin, recipient);
}