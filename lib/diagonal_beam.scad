function beam_height_from_diagonal(
    beam_diagonal_length,
    beam_width
) = sqrt(pow(beam_diagonal_length, 2) - pow(beam_width, 2));

function beam_diagonal_length(
    beam_width,
    beam_length
) = sqrt(pow(beam_length, 2) + pow(beam_width, 2));

function beam_diagonal_angle(
    beam_width,
    beam_length
) = atan(beam_width / beam_length);

function beam_diagonal_to_horizontal_angle(
    area_width,
    beam_diagonal_length
) = acos(area_width / beam_diagonal_length);

function diagonal_beam_offset_after_rotation(
    beam_width,
    beam_angle
) = beam_width * sin(beam_angle);

function diagonal_beam_angle(
    area_width,
    area_height,
    beam_width,
    beam_length
) = 
    beam_diagonal_angle(
        beam_width,
        beam_length
    )
    + beam_diagonal_to_horizontal_angle(
        area_width,
        beam_diagonal_length(beam_width, beam_length)
    ); 

function upper_corner_height(
    beam_width,
    beam_length,
    beam_angle
) = beam_width * cos(beam_angle) + beam_length * sin(beam_angle);

function loop(
    area_width,
    area_height,
    beam_width,
    current_beam_length,
    prev_beam_length,
    step
) = upper_corner_height(
        beam_width,
        current_beam_length,
        diagonal_beam_angle(
            area_width,
            area_height,
            beam_width,
            current_beam_length
        )
    ) > area_height
        ? prev_beam_length
        : loop(
            area_width,
            area_height,
            beam_width,
            current_beam_length = current_beam_length + step,
            prev_beam_length = current_beam_length,
            step
        );

/*
This iterates recursively to find the ideal beam length.
This is not optimal, but precise.
The math is based on this solution to a similar problem: https://www.iwpcug.org/davidbro/puz0902.htm
And this problem is: https://artofproblemsolving.com/community/c4h482815p2705285

This in still my very verbose "figuring it all out" code, but:
TODO: generalize, use BOSL2 `root_find`, write the code for other diagonally positioned pieces
*/
function diagonal_beam_length(
    area_width,
    area_height,
    beam_width,
    accuracy = 1
) =
    loop(
        area_width = area_width,
        area_height = area_height,
        beam_width = beam_width,
        current_beam_length = beam_height_from_diagonal(
            max(area_width, area_height),
            beam_width
        ),
        prev_beam_length = 0,
        step = accuracy
    );
