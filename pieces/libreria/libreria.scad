use <../../lib/diagonal_beam.scad>;
use <../../lib/lumber.scad>;

function shelf_support_spacing(
    height,
    shelf_support_width,
    shelf_support_count
) = (height - shelf_support_width) / (shelf_support_count - 1);


module shelf (
    width,
    depth,
    thickness
) {
    rotate([
        90,
        0,
        90
    ])
    plank(
        width = depth,
        thickness = thickness,
        length = width
    );
}
module upright (
    height,
    max_shelf_count,
    depth,
    beam_width,
    beam_thickness,
    shelf_support_width,
    shelf_support_thickness
) {
    beam_to_beam = depth - beam_thickness * 2;

    // front beam
    beam(
        width = beam_width,
        thickness = beam_thickness,
        length = height
    );

    // rear beam
    translate([
        0,
        beam_to_beam + beam_thickness,
        0
    ])
    beam(
        width = beam_width,
        thickness = beam_thickness,
        length = height
    );

    upright_diagonal_beam_length = diagonal_beam_length(
        area_width = beam_to_beam,
        area_height = height,
        beam_width = beam_thickness
    );

    upright_diagonal_beam_angle = diagonal_beam_angle(
        area_width = beam_to_beam,
        area_height = height,
        beam_width = beam_thickness,
        beam_length = upright_diagonal_beam_length
    );

    echo(upright_diagonal_beam_angle,upright_diagonal_beam_length);

    // diagonal beam
    translate([
        beam_width,
        beam_thickness + diagonal_beam_offset_after_rotation(
            beam_width = beam_thickness,
            beam_angle = upright_diagonal_beam_angle
        ),
        0
    ])
    rotate([
        90 - upright_diagonal_beam_angle ,
        0,
        180,
    ])
    beam(
        width = beam_width,
        thickness = beam_thickness,
        length = upright_diagonal_beam_length
    );

    // shelf supports
    shelf_support_count = max_shelf_count + 2;
    for (side = [0: 1 : 1])
    for (i = [0: 1 :  shelf_support_count -1]) {
        translate([
            side * (beam_width + shelf_support_thickness),
            depth,
            i * shelf_support_spacing(
                height,
                shelf_support_width,
                shelf_support_count
            )
        ])
        rotate([
            90,
            -90,
            0
        ])
        beam(
            width = shelf_support_width,
            thickness = shelf_support_thickness,
            length = depth
        );
    }
}

module libreria (
    height = 2000,
    max_shelf_count = 12,
    sections = 1,
    shelf_width = 1000,
    shelf_depth = 300,
    shelf_thickness = 10,
    upright_beam_width = 70,
    upright_beam_thickness = 30,
    shelf_support_width = 30,
    shelf_support_thickness = 10,
    shelves = [
        [1, 3, 5, 7, 9, 11]
    ]
) {
    for (upright_index = [0: 1 : sections]) {

        translate([
            shelf_support_thickness + upright_index * (upright_beam_width + shelf_width),
            0,
            0
        ])
        upright(
            height = height,
            max_shelf_count = max_shelf_count,
            depth = shelf_depth,
            beam_width = upright_beam_width,
            beam_thickness = upright_beam_thickness,
            shelf_support_width = shelf_support_width,
            shelf_support_thickness = shelf_support_thickness
        );

        for (shelf_position = shelves[upright_index])
        assert(shelf_position > 0, "cannot position be lower than '1'")
        assert(shelf_position <= max_shelf_count, "shelf position higher than shelf count")
        translate([
            shelf_support_thickness + upright_beam_width + upright_index * (upright_beam_width + shelf_width),
            0,
            shelf_support_width + shelf_position * shelf_support_spacing(
                    height,
                    shelf_support_width,
                    shelf_support_count = max_shelf_count + 2
            )
        ])
        shelf(
            width = shelf_width,
            depth = shelf_depth,
            thickness = shelf_thickness
        );
    }
}

color("wheat")
libreria();

color("burlywood")
translate([
    0,
    2000,
    0
])
libreria(
    height = 1600,
    shelf_depth = 500,
    max_shelf_count = 6,
    upright_beam_thickness =80,
    upright_beam_width = 50,
    shelf_width = 700,
    shelf_thickness = 20,
    sections = 3,
    shelves = [
        [1, 3, 6],
        [1, 5],
        [1, 3, 6]

    ]
);