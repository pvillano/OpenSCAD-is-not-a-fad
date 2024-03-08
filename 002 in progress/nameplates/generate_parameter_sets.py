import json

base = {
    "fileFormatVersion": "1",
    "parameterSets": {
        "000 Clip": {
            "Fit_Width": "true",
            "Layer": "Clip",
            "Name": "_"
        },
    }
}
parameter_sets = base["parameterSets"]
with open("names.txt", 'r') as f:
    for name in f:
        name = name.strip()
        for layer in ["White", "Gold", "Blue"]:
            parameter_sets[name + ' ' + layer] = {
                "Fit_Width": "true",
                "Layer": layer,
                "Name": name,
            }

with open("nameplate.json", 'w') as f:
    json.dump(base, f, sort_keys=True, indent=4)
