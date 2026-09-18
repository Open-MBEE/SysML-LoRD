package lord

import (
	"encoding/json"
	"errors"
	"strings"
	"testing"
)

func TestResumeReplaysTheGameToTheSameState(t *testing.T) {
	source := modelSource(t)
	g := newGame(t, 42, Character{Name: "Lady Jane", Female: true, Class: "thievingSkills"})
	play(t, g, "W", map[string]string{"weapon": "town.weapons.stick"})
	play(t, g, "K", nil)
	play(t, g, "D", map[string]string{"amount": "100"})
	play(t, g, "R", nil)
	play(t, g, "F", nil)
	play(t, g, "L", nil)
	play(t, g, "A", nil)
	if _, err := g.Play("Z", nil); !errors.Is(err, ErrNoSuchCommand) {
		t.Fatalf("Z: %v", err)
	}
	saved := g.Save()
	if saved.Seed != 42 || saved.Character.Name != "Lady Jane" || len(saved.Moves) != 7 {
		t.Fatalf("save = %+v", *saved)
	}

	data, err := json.Marshal(saved)
	if err != nil {
		t.Fatal(err)
	}
	var loaded Save
	if err := json.Unmarshal(data, &loaded); err != nil {
		t.Fatal(err)
	}
	r, err := Resume(source, &loaded)
	if err != nil {
		t.Fatal(err)
	}
	defer r.Close()
	if got, want := *snapshot(t, r), *snapshot(t, g); got != want {
		t.Fatalf("resumed = %+v\nwant      %+v", got, want)
	}
	if r.Location() != g.Location() {
		t.Fatalf("location = %s, want %s", r.Location(), g.Location())
	}
	if again, _ := json.Marshal(r.Save()); string(again) != string(data) {
		t.Fatalf("the resumed game saves as\n%s\nwant\n%s", again, data)
	}
	next := "L"
	if g.Location() == "fighting" {
		next = "A"
	}
	o1 := play(t, g, next, nil)
	o2 := play(t, r, next, nil)
	if *o1.After != *o2.After {
		t.Fatalf("the dice diverged after the resume:\n%+v\n%+v", *o1.After, *o2.After)
	}
	view, err := r.Returned()
	if err != nil {
		t.Fatal(err)
	}
	if !strings.HasPrefix(view.Lines[0], "Welcome back, Lady Jane.") {
		t.Fatalf("lines = %q", view.Lines)
	}
}

func TestSaveCarriesTheSeedAsAString(t *testing.T) {
	data, err := json.Marshal(&Save{Seed: 1<<64 - 1})
	if err != nil {
		t.Fatal(err)
	}
	if !strings.Contains(string(data), `"seed":"18446744073709551615"`) {
		t.Fatalf("save = %s", data)
	}
	var loaded Save
	if err := json.Unmarshal(data, &loaded); err != nil || loaded.Seed != 1<<64-1 {
		t.Fatalf("seed = %d, %v", loaded.Seed, err)
	}
}

func TestResumeRefusesASaveOfAnotherModel(t *testing.T) {
	source := modelSource(t)
	saved := &Save{Model: ModelDigest([]byte("package Other;")), Seed: 1}
	if _, err := Resume(source, saved); !errors.Is(err, ErrStaleSave) {
		t.Fatalf("another model's save: %v", err)
	}
	if _, err := Resume(source, nil); !errors.Is(err, ErrStaleSave) {
		t.Fatalf("no save: %v", err)
	}
}

func TestResumeRefusesAMoveThatNoLongerPlays(t *testing.T) {
	source := modelSource(t)
	saved := &Save{Model: ModelDigest(source), Seed: 1, Moves: []Move{{Key: "F"}, {Key: "Z"}}}
	_, err := Resume(source, saved)
	if !errors.Is(err, ErrStaleSave) || !strings.Contains(err.Error(), "move 2 (Z)") {
		t.Fatalf("a move off the menu: %v", err)
	}
}
