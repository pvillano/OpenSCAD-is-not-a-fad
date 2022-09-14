"""
what's the strategy?
# goals
 * an equal distribution of each letter,
 * or an arbitrary distribution
 * no self-combined letters
 *

# strategy 1
 * only use printing on one side, each of the 6 sideways-printable letters is paired with 6 non-sideways printable letters

"""


def main():
    all = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    left = "EFIKLZ"  # most desirable, can print with any other letter
    upright = "KLMNX"
    upsidedown = "KMNTVWXY"
    # right = "AZ" # not helpful

    left_set = set(left) - set(upright + upsidedown)
    upright_set = set(upright)
    upsidedown_set = set(upsidedown) - set(upright)
    problematic_set = set(all) - set(upright + upsidedown + left)
    pass


if __name__ == '__main__':
    main()
