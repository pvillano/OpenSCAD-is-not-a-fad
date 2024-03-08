import json

base = {
    "fileFormatVersion": "1",
    "parameterSets": ...
}
parameter_sets = dict()
with open("names.txt", 'r') as f:
    for name in f:
        name = name.strip()
        for layer in ["White", "Gold", "Blue", "Base"]:
            parameter_sets[name + ' ' + layer] = {
                "Fit_Width": "true",
                "Layer": "All",
                "Name": name,
            }
base["parameterSets"] = parameter_sets

with open("nameplate.json", 'w') as f:
    json.dump(base, f, sort_keys=True, indent=4)
