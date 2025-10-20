use std::env::args;
use std::fs::read_to_string;
use std::iter::zip;

fn main() {
    let filename = args().nth(1).unwrap();
    let contents = read_to_string(filename).unwrap();
    let (mut lefts, mut rights): (Vec<i32>, Vec<i32>) = contents
        .lines()
        .map(|line| -> (i32, i32) {
            let mut it = line.split_whitespace().map(|x| x.parse().unwrap());
            (it.next().unwrap(), it.next().unwrap())
        })
        .unzip();
    lefts.sort();
    rights.sort();
    let sum: i32 = zip(lefts, rights).map(|(l, r)| (l - r).abs()).sum();
    println!("{}", sum);
}
