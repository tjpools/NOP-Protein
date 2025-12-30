// nop_benchmark.rs
// Rust program to count NOPs (empty inline asm) executed in 1 second
use std::time::{SystemTime, Duration};

fn main() {
    let mut nops: u64 = 0;
    let start = SystemTime::now();
    while start.elapsed().unwrap() < Duration::from_secs(1) {
        unsafe { std::arch::asm!("nop"); }
        nops += 1;
    }
    println!("NOPs executed: {}", nops);
}
