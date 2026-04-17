
import fs from 'fs';
const content = fs.readFileSync('c:/ebzim-buraux/lib/screens/home_screen.dart', 'utf8');
let stack = [];
let lines = content.split('\n');
for (let i = 0; i < lines.length; i++) {
    let line = lines[i];
    for (let j = 0; j < line.length; j++) {
        let char = line[j];
        if (char === '{' || char === '[' || char === '(') {
            stack.push({char, line: i + 1});
        } else if (char === '}' || char === ']' || char === ')') {
            if (stack.length === 0) {
                console.log(`Extra closing ${char} at line ${i + 1}`);
            } else {
                let last = stack.pop();
                if ((char === '}' && last.char !== '{') || (char === ']' && last.char !== '[') || (char === ')' && last.char !== '(')) {
                    console.log(`Mismatch: ${last.char} at line ${last.line} closed by ${char} at line ${i + 1}`);
                }
            }
        }
    }
}
if (stack.length > 0) {
    console.log(`Unclosed brackets:`, stack);
} else {
    console.log('Brackets balanced!');
}
