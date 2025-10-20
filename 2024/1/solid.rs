use std::env;
use std::fs;
use std::iter::zip;

fn main() {
    let filename = env::args().nth(1).unwrap();
    let contents = fs::read_to_string(filename).unwrap();
    let mut lefts: Vec<i32> = Vec::new();
    let mut rights: Vec<i32> = Vec::new();
    for line in contents.lines() {
        let mut it = line.split_whitespace();
        lefts.push(it.next().unwrap().parse().unwrap());
        rights.push(it.next().unwrap().parse().unwrap());
    }
    lefts.sort();
    rights.sort();
    let sum: i32 = zip(lefts, rights).map(|(l, r)| (l - r).abs()).sum();
    println!("{}", sum);
}
