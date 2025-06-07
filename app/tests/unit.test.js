const { add } = require('../src/index');

describe('funkcja add', () => {
    it('powinna zwrócić sumę dwóch liczb dodatnich', () => {
        expect(add(2, 3)).toBe(5);
    });

    it('powinna zwrócić sumę liczby ujemnej i dodatniej', () => {
        expect(add(-1, 1)).toBe(0);
    });

    it('powinna zwrócić poprawnie wynik dla wartości zerowych', () => {
        expect(add(0, 0)).toBe(0);
    });

    it('powinna działać z wartościami zmiennoprzecinkowymi', () => {
        expect(add(1.5, 2.25)).toBeCloseTo(3.75);
    });
});
