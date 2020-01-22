res = 30;
doorRangeA = [0:2];
doorRangeB = [0:60];
Tt = 0;
Tr = 0;


module Casing(){
  rotate([90,0,0]) import("Body1.stl",convexity=res/15);

}

module cutOut(){
    linear_extrude(h = 100,center = true, convexity = 10, twist = 0, slices = res*2, scale = 1){
        polygon(points = [[0,0],[25,0],[40,25],[70,25],[70,70],[0,70]], paths = [[0,1,2,3,4,5,6]],convexity = 1);
    }
}

module doors(){
    intersection(){
        Casing();
        translate([-13,0,1.1]) rotate([180,-90,90]) cutOut();
    }
}

module doorLeft(){
    intersection(){
        scale([0.99,0.99,0.99]) doors();
        translate([0,-100,0]) cube([200,200,200],center=true);
    }
}

module doorRight(){
    intersection(){
        scale([0.999,0.999,0.999]) doors();
        translate([0,100,0]) cube([200,200,200],center=true);
    }
}

module assembly(){
    difference(){
        union(){
            Casing();
            translate([0,0,-9]) rotate([0,0,0]) cylinder(r1=30,r2=48,h=20,center=true,$fn=res);
        }
        for (i=[0:3]){
            rotate([0,-14,i*90]) translate([34,0,-21]) cylinder(r=6,h=10,center=true,$fn=res);
        }
        translate([-13,0,1.1]) rotate([180,-90,90]) cutOut();
    }
    T = $t*60;
    if  (T < 3) {
        Tt = T;
        Tr = 0;
        echo("Time=",T," Translation=",Tt," Rotation=",Tr);
        rotate([0,0,-Tt]) translate([Tr,-Tr,0]) doorLeft();
        rotate([0,0,Tt]) translate([Tr,Tr,0]) doorRight();
    } else {
        Tt = 3;
        Tr = (T - 3);
        echo("Time=",T," Translation=",Tt," Rotation=",Tr);
        rotate([0,0,-Tr]) translate([Tt,-Tt,0]) doorLeft();
        rotate([0,0,Tr]) translate([Tt,Tt,0]) doorRight();
    }
}

module cutThrough(){
    difference(){
        assembly();
        translate([0,-100,0]) cube([200,200,200],center=true);
    }
}

//cutThrough();
assembly();