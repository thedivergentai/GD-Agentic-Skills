# Manual testing checklist

Automate critical paths first; use this for release smoke when CI cannot cover feel.

## Gameplay

- [ ] Movement all directions
- [ ] Jump / combat numbers match design
- [ ] Enemy AI responds

## UI

- [ ] Buttons / focus navigation
- [ ] Readable at min supported resolution

## Audio

- [ ] Music + SFX trigger; bus levels balanced

## Performance

- [ ] Stable target FPS
- [ ] No stutter spikes; memory stable

## Test folder layout (suggested)

```
res://test/
├── unit/
├── integration/
└── fixtures/
```
