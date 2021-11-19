$fn=60;


minimum_radius=10.0;
maximum_radius=20.0;
step=0.5;
overcut=0.5;
thickness = 2;

function margin(r) = 3.0+r/2;

function needed_length(r) = r * 2.0 + margin(r);

function sum_needed_length(n) = 
    n <= minimum_radius
        ? needed_length(n)
        : sum_needed_length(n-1.0) + needed_length(n);

circumference = sum_needed_length(maximum_radius) - margin(minimum_radius) / 4 - (needed_length(maximum_radius)/2) + (needed_length(minimum_radius)/2);

radius = circumference/(2.0*PI);

module cutout(r) {
    // calculate distance along circumference for this radius center point
    d = sum_needed_length(r) - needed_length(r);
    degrees = d / circumference * 360;
    rotation = (45 - degrees)%360;
    
    x = sin(degrees) * radius;
    y = cos(degrees) * radius;
    
    translate(
        [x, y, -overcut]
    ) cylinder(
        h=thickness+overcut*2,
        r=r
    );
    
    translate(
        [x, y, -overcut]
    ) rotate(
        [0, 0, rotation]
    ) linear_extrude(
        height=thickness + overcut*2
    ) polygon([
        [-r, 0],
        [-r, r*2],
        [r*2, -r],
        [0, -r]
    ]);
    
}

module radius_text(r) {
    d = sum_needed_length(r) - needed_length(r);
    degrees = d / circumference * 360;
    
    text_center_distance = radius - r - minimum_radius;
    
    translate(
        [sin(degrees) * text_center_distance, cos(degrees) * text_center_distance, -overcut]
    ) rotate(
        [0, 0, 180-degrees]
    ) linear_extrude(
        thickness + overcut*2
    ) text(
        str(r),
        size = 4,
        font = "Liberation Sans",
        halign = "center"
    );
}

difference() {
    cylinder(thickness, radius, radius);
}
/*
    for (i = [minimum_radius : step : maximum_radius]) {
        cutout(i);
        radius_text(i);
    }
*/
cutout(10.5);
cutout(10);







