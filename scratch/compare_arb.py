import json

def compare_arb(file1, file2):
    with open(file1, 'r', encoding='utf-8') as f1:
        data1 = json.load(f1)
    with open(file2, 'r', encoding='utf-8') as f2:
        data2 = json.load(f2)
    
    keys1 = set(data1.keys())
    keys2 = set(data2.keys())
    
    missing = keys1 - keys2
    print(f"Keys in {file1} but not in {file2}:")
    for k in sorted(missing):
        print(k)

compare_arb('lib/core/localization/l10n/app_ar.arb', 'lib/core/localization/l10n/app_fr.arb')
