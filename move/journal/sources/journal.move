module journal::journal;

use std::string::String;
use std::vector;
use sui::clock::{Self, Clock};
use sui::object::{Self, UID};
use sui::tx_context::{Self, TxContext};

/// An owned Sui object representing a journal
public struct Journal has key, store {
    id: UID,
    owner: address,
    title: String,
    entries: vector<Entry>,
}

/// A struct representing a journal entry, to be stored in the Journal object
public struct Entry has store {
    content: String,
    create_at_ms: u64,
}

/// Creates a new journal with the given title
public fun new_journal(title: String, ctx: &mut TxContext): Journal {
    Journal {
        id: object::new(ctx),
        owner: tx_context::sender(ctx),
        title,
        entries: vector::empty(),
    }
}

/// Adds a new entry to the journal
public fun add_entry(journal: &mut Journal, content: String, clock: &Clock, ctx: &TxContext) {
    // Verify the caller is the journal owner
    assert!(journal.owner == tx_context::sender(ctx), 0);

    // Create a new entry with current timestamp
    let entry = Entry {
        content,
        create_at_ms: clock::timestamp_ms(clock),
    };

    // Add the entry to the journal's entries vector
    vector::push_back(&mut journal.entries, entry);
}
