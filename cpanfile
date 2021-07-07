requires 'perl', '>= 5.020';

requires 'App::Cmd', '>= 0.333';
requires 'Readonly', '>= 2.05';

on test => sub {
    requires 'Test::More', '0.96';
};
