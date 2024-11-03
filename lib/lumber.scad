/*
These are abstractions for different types of lumber.

They serve multiple purposes:
- to help with naming variables related with orientation
- to create bills of material (TODO)

They're all oriented vertically, flat side front.
*/

module beam (
    width,
    thickness,
    length
) {
    cube(
        size = [
            width,
            thickness,
            length
        ],
        center = false
    );
}

module plank(
    width,
    thickness,
    length
) {
    cube(
        size = [
            width,
            thickness,
            length
        ],
        center = false
    );
}