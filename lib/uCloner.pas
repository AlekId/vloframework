unit uCloner;

interface

type
    ICloneable = interface
        ['{F6676376-D14B-4860-AD5B-D920DF25E52D}']
        function Clone: TObject;
    end;

    IAssignable = interface
        ['{11949BA5-E160-417C-A53C-4EE485BDDE34}']
        procedure Assign(obj: TObject);
    end;

implementation

end.
