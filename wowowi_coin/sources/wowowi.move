/// Implements a coin with limited supply.
module suiworkshoptoken::wowowi;

use sui::coin::{Self, TreasuryCap};
use sui::coin_registry::{Self, CoinRegistry};
use sui::object::UID;
use sui::tx_context::TxContext;
use sui::transfer;

const TOTAL_SUPPLY: u64 = 1_000_000_000_000000;

public struct WOWOWI has key { id: UID }

#[allow(lint(self_transfer))]
public fun new_currency(registry: &mut CoinRegistry, ctx: &mut TxContext) {
    let (currency, treasury_cap) = coin_registry::new_currency<WOWOWI>(
        registry,
        6,
        b"WOWOWI".to_string(),
        b"WOWOWI".to_string(),
        b"YO WAKARANAI KOK TANYA WATASHI".to_string(),
        b"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQh1cpBR8d2D2P55Z2kQzlr6uGuhRfWzEnoVQ&s".to_string(),
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