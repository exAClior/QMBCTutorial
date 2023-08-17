#include <iostream>
#include <string>

using namespace std;

class Pet {
    public:
        string name;
};

string meets(Pet a, Pet b) {
    return "FallBACK";
}

void encounter(Pet a, Pet b) {
    string verb = meets(a, b);
    cout << a.name << " meets " << b.name << " " << verb << endl;
}

class Dog : public Pet {};
class Cat : public Pet {};

string meets(Dog a, Dog b) {
    return "sniffs";
}
string meets(Dog a, Cat b) {
    return "chases";
}
string meets(Cat a, Dog b) {
    return "hisses";
}
string meets(Cat a, Cat b) {
    return "slinks";
}

int main(){
    Dog sam; sam.name = "Sam";
    Dog bob; bob.name = "Bob";
    Cat erwin; erwin.name = "Erwin";
    Cat tom; tom.name = "Tom";

	encounter(sam, bob);
	encounter(sam, erwin);
	encounter(erwin, bob);
	encounter(erwin, tom);

    return 0;
}
